resource "aws_key_pair" "mykey" {
	key_name = "siva_key"
	public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "windows-resource" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "<ins-type>"
  key_name = "${aws_key_pair.mykey.key_name}"
  vpc_security_group_ids = "<sg-id>"
  subnet_id = "<subnet-id>"
  tags{
  Key = "Name"
  value = "Windows-06082018"
  }



  connection {
		user = "${var.INSTANCE_USERNAME}"
		private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
	}
}
