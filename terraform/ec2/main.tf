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
    source      = "../app/"
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
      "sudo gunicorn --log-level debug -b 0.0.0.0:8000 api:app" # Execute a aplicação em segundo plano
    ]
  }
}

output "ec2_global_ips" {
  value = ["Application Public IP:", "${aws_instance.my_ec2_instance.*.public_ip}"]
}
