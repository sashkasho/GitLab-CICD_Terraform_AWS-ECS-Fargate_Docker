#instance_type = "t3.micro"
#aws_security_group_name = "app-alb-sg"

#ecr_image_frontend = "sholalexandra/app-frontend:latest"
#ecr_image_backend = "sholalexandra/app-backend:latest"

/* ecr_image_backend = "sholalexandra/backend-app-db-env:latest"
ecr_image_frontend = "sholalexandra/frontend-app-zero-env:latest" */

#ecr_image_frontend = "910702143091.dkr.ecr.ca-central-1.amazonaws.com/app-backend-gitlab:latest"
#ecr_image_backend = "910702143091.dkr.ecr.ca-central-1.amazonaws.com/app-frontend-gitlab:latest"

aws_security_group_description = "Inbound: 80, Outbound: all"
aws_security_group_description_ecs = "Inbound: 80 from ALB Security Group, Outbound: all"
secondary_private_ips = [ "10.0.1.100" ]
security_group_cidr_blocks = [ "0.0.0.0/0" ]
aws_key_pair_name = "app_key"
aws_key_pair_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbsLwuNRFHaqnySacLCi7s5RhMgXY5aRx5I3eU0zeGow4XOCSipBYL0itSyCeiMZNN5/sx7DeQAaNVsA391aLAboPqfpvraQ6jxaNbN8oeQtnZwkW3Zpk5a22RUvdZUW5NoFTV0PMQegrChvQB4QViN1YhRYm49Tny8QhcJYOvsTrx6WUy4aBrB/pdzbwyQT7ZNlDCfXtVMTnCUqujfPRlUbt+IwK4U6+JshW/XMdWaxHerxe8sBN3unIFX7VQlB4Kk/7pt65pjFszkL76Ec9yZR3Nq7kPpAmk2DxvsBppzsCSpUFqzsg2DzZu+J0F37bDO5sLCuMqIz+nvU9MVlO62mtgziSsS3niVHmFx5Y0Lm/Ra4jqIOJBs/4sh2sMsVci1DUXW5WhUBoNHuRVBwqtkRmUklfvVXPqUSXjlZP+iHV5nTRnwGCJ8AS0W0SLxPpIabi5BIAeORi0L7hTYllWzVaTaS3ruzDfJreNIY8UFqHbJ4QLPgYLtM0NEhIiAAU= shol.alexandra@gmail.com"