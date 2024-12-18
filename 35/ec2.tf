# resource "aws_instance" "ad" {
#   ami = local.inputs.servers.ad.ami_id
#   instance_type = local.inputs.servers.ad.instance_type
#   availability_zone = local.inputs.servers.ad.availability_zone
#   private_ip = local.inputs.servers.ad.private_ip
#   subnet_id = local.inputs.servers.ad.subnet_id
#   key_name = local.inputs.servers.ad.key_pair
#   iam_instance_profile = local.inputs.servers.ad.instance_profile
#   vpc_security_group_ids = [local.inputs.default_sg_id]  
#   tags = merge(local.inputs.tags, { Name = "${local.inputs.servers.ad.name}" } )
# }

# resource "aws_instance" "cdr" {
#   associate_public_ip_address = true
#   ami = local.inputs.servers.cdr.ami_id
#   instance_type = local.inputs.servers.cdr.instance_type
#   availability_zone = local.inputs.servers.cdr.availability_zone
#   private_ip = local.inputs.servers.cdr.private_ip
#   subnet_id = local.inputs.servers.cdr.subnet_id
#   key_name = local.inputs.servers.cdr.key_pair
#   iam_instance_profile = local.inputs.servers.cdr.instance_profile
#   vpc_security_group_ids = [local.inputs.default_sg_id]  
#   tags = merge(local.inputs.tags, { Name = "${local.inputs.servers.cdr.name}" } )
# }

resource "aws_instance" "sftp" {
  associate_public_ip_address = true
  ami = local.inputs.servers.sftp.ami_id
  instance_type = local.inputs.servers.sftp.instance_type
  availability_zone = local.inputs.servers.sftp.availability_zone
  private_ip = local.inputs.servers.sftp.private_ip
  subnet_id = local.inputs.servers.sftp.subnet_id
  key_name = local.inputs.servers.sftp.key_pair
  iam_instance_profile = local.inputs.servers.sftp.instance_profile
  vpc_security_group_ids = [local.inputs.default_sg_id] 
  
  tags = merge(local.inputs.tags, { Name = "${local.inputs.servers.sftp.name}" } )
}

# resource "aws_instance" "sas" {
#   associate_public_ip_address = true
#   ami = local.inputs.servers.sas.ami_id
#   instance_type = local.inputs.servers.sas.instance_type
#   availability_zone = local.inputs.servers.sas.availability_zone
#   private_ip = local.inputs.servers.sas.private_ip
#   subnet_id = local.inputs.servers.sas.subnet_id
#   key_name = local.inputs.servers.sas.key_pair
#   iam_instance_profile = local.inputs.servers.sas.instance_profile
#   vpc_security_group_ids = [local.inputs.default_sg_id]  
#   tags = merge(local.inputs.tags, { Name = "${local.inputs.servers.sas.name}" } ) 
# }

# resource "aws_instance" "rdg" {
#   associate_public_ip_address = true
#   ami = local.inputs.servers.rdg.ami_id
#   instance_type = local.inputs.servers.rdg.instance_type
#   availability_zone = local.inputs.servers.rdg.availability_zone
#   private_ip = local.inputs.servers.rdg.private_ip
#   subnet_id = local.inputs.servers.rdg.subnet_id
#   key_name = local.inputs.servers.rdg.key_pair
#   iam_instance_profile = local.inputs.servers.rdg.instance_profile
#   vpc_security_group_ids = [local.inputs.default_sg_id]  
#   tags = merge(local.inputs.tags, { Name = "${local.inputs.servers.rdg.name}" } )
# }

# resource "aws_instance" "sgw" {
#   ami = local.inputs.servers.sgw.ami_id
#   instance_type = local.inputs.servers.sgw.instance_type
#   availability_zone = local.inputs.servers.sgw.availability_zone
#   private_ip = local.inputs.servers.sgw.private_ip
#   subnet_id = local.inputs.servers.sgw.subnet_id
#   key_name = local.inputs.servers.sgw.key_pair
#   iam_instance_profile = local.inputs.servers.sgw.instance_profile
#   vpc_security_group_ids = [local.inputs.default_sg_id]  
#   tags = merge(local.inputs.tags, { Name = "${local.inputs.servers.sgw.name}" } )
# }

