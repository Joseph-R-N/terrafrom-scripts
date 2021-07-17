provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "ec2DB" {
    ami = "ami-0233c2d874b811deb"
    instance_type = "t2.micro"
    tags = {
        Name = var.ec2name
    }  
}

variable "ec2name" {
    type = string
    default = "DB Server"
}

output "dbserverpvtIP" {
  value = aws_instance.ec2DB.private_ip
}

resource "aws_instance" "ec2WEB" {
    ami = "ami-0233c2d874b811deb"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.sgwebserver.name]
    user_data = file("server-script.sh")
    tags = {
        Name = var.ec2webName
    }  
    
}

variable "ec2webName" {
    type = string
    default = "Web Server"
}

resource "aws_eip" "elasticipwebserver" {
    instance = aws_instance.ec2WEB.id
}

resource "aws_security_group" "sgwebserver" {
    name = "Webtraffic"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }  

        egress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }  

        egress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

}
