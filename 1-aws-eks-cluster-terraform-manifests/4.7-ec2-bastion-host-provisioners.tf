# Create a Null Resource and Provisioners
resource "null_resource" "copy_ec2_keys" {
  depends_on = [module.ec2_public]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type     = "ssh"
    host     = aws_eip.bastion_eip.public_ip    
    user     = "ec2-user"
    password = ""
    private_key = file("private-key/aws-devops-key.pem")
  }  

## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/aws-devops-key.pem"
    destination = "/tmp/aws-devops-key.pem"
  }
## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/aws-devops-key.pem /home/ec2-user/aws-devops-key.pem",
      "sudo chown ec2-user:ec2-user /home/ec2-user/aws-devops-key.pem",
      "sudo chmod 400 /home/ec2-user/aws-devops-key.pem"
    ]
  }
## Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    #command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    command = "mkdir -p local-exec-output-files && echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> local-exec-output-files/creation-time-vpc-id.txt"
    #working_dir = "local-exec-output-files/"
    #on_failure = continue
  }

}