data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] 
}
variable "key_name" {
  description = "SSH Key Name For Authentication"
  type        = string
  default     = "ubuntu"
}

resource "tls_private_key" "ubuntu" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ubuntu.public_key_openssh

}

resource "aws_instance" "my_ec2_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.securityGroup_id]
  key_name               = aws_key_pair.generated_key.key_name

  connection {
  type        = "ssh"
  user        = "ubuntu" 
  private_key = tls_private_key.ubuntu.private_key_pem
  host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /opt/app",  # Cria o diretório /opt/app se ele não existir
      "sudo chown ubuntu:ubuntu /opt/app"  # Ajusta as permissões do diretório
    ]
  }

  provisioner "file" {
    source      = "app/"
    destination = "/opt/app"
    connection {
     type        = "ssh"
     user        = "ubuntu" 
     private_key = tls_private_key.ubuntu.private_key_pem 
     host        = self.public_ip
   }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3-pip",
      "sudo pip3 install gunicorn",
      "sudo pip3 install -r /opt/app/requirements.txt",
      "cd /opt/app",
      "sudo nohup gunicorn --log-level debug -b 0.0.0.0:8000 api:app &", # Execute a aplicação em segundo plano
      "sleep 15",
      "curl -sv 0.0.0.0:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"first post!","content_id":1}'",
      "sleep 5",
      "curl -sv 0.0.0.0:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"ok, now I am gonna say something more useful","content_id":1}'",
      "sleep 5",
      "curl -sv 0.0.0.0:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I agree","content_id":1}'",
      "sleep 5",
      "curl -sv 52.7.5.16:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I guess this is a good thing","content_id":2}'",
      "sleep 5",
      "curl -sv 52.7.5.16:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"charlie@example.com","comment":"Indeed, dear Bob, I believe so as well","content_id":2}'",
      "sleep 5",
      "curl -sv 52.7.5.16:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"eve@example.com","comment":"Nah, you both are wrong","content_id":2}'",
      "sleep 5",
      "curl -sv 52.7.5.16:8000/api/comment/list/1",
      "sleep 5",
      "curl -sv 52.7.5.16:8000/api/comment/list/2",
      "sleep 5",
      "curl http://localhost:8000 && echo 'Application is up and running'"
    ]
  }
}

output "ec2_global_ips" {
  value = ["Application Public IP:", "${aws_instance.my_ec2_instance.*.public_ip}"]
}
