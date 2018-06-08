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
  user_data = <<EOF
  <powershell>
  net user ${var.INSTANCE_USERNAME} ${var.INSTANCE_PASSWORD} /add
  net localgroup administrators ${var.INSTANCE_USERNAME} /add

  winrm quickconfig -q
  winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
  winrm set winrm/config '@{MaxTimeoutms="1800000"}'
  winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  winrm set winrm/config/service/auth '@{Basic="true"}'

  netsh advfirewall firewall add rule name="WinRM 5985" dir=in localport=5985 action=allow
  netsh advfirewall firewall add rule name="WinRM 5986" dir=in localport=5986 action=allow

  net stop winrm
  sc.exe config winrm start=auto
  net start winrm
  </powershell>
  EOF
  tags{
    key = "Name"
    value = "Windows-06082018"
  }


  connection {
    type = "winrm"
		user = "${var.INSTANCE_USERNAME}"
		password = "${var.INSTANCE_PASSWORD}"
	}
}
