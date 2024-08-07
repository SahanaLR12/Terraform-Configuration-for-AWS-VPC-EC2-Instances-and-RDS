# Create the EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0427090fd1714168b"  # Replace with a valid AMI for your region
  instance_type = "t2.micro"
  key_name = "(give the keypair name)"
  subnet_id     = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
  tags = {
    Name = "example-ec2-instance"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("(keypair path)")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install httpd php php-mysqli mariadb105 -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo chown -R ec2-user /var/www/"
    ]
  }

  provisioner "file" {
    content     = <<-EOF
    <?php

define('DB_SERVER', '${aws_db_instance.example.address}');
define('DB_USERNAME', 'admin');
define('DB_PASSWORD', '(give password)');
define('DB_DATABASE', 'exampledb');

?>
  EOF
    destination = "/var/www/html/dbinfo.inc"
  }

  provisioner "file" {
    source      = "./index.php"
    destination = "/var/www/html/index.php"
  }
}