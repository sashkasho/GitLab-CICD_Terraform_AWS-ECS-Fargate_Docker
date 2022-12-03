provider "aws" {
  region = var.region
}

# DATA BLOCKS
data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# NETWORK MODULE
module "network_block" {
  source = "./modules/network"
  aws_vpc_cidr_block = "10.0.0.0/16"
  #aws_subnet_cidr_block = "10.0.1.0/24"
  availability_zone = [ "ca-central-1a", "ca-central-1b", "ca-central-1d" ]
  enable_dns_support = true
  enable_dns_hostnames = true
  #map_public_ip_on_launch = true
  aws_route_table_route_cidr = "0.0.0.0/0"
}

# SECURITY GROUPS 
resource "aws_security_group" "alb_sg" {
  name        = "app-alb-sg"
  description = var.aws_security_group_description
  vpc_id      = module.network_block.vpc_id

  /* ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = var.protocol_tcp
    cidr_blocks      = var.security_group_cidr_blocks
  } */

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.security_group_cidr_blocks
  }

  ingress {
    description      = "Backend"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = var.security_group_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.security_group_cidr_blocks
  }

  tags = {
    Name = "app-alb-sg"
  }
}

resource "aws_security_group" "ecs_tasks_sg" {
  name        = "ecs_tasks_sg"
  description = var.aws_security_group_description_ecs
  vpc_id      = module.network_block.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.security_group_cidr_blocks
  }
}

resource "aws_key_pair" "test_key" {
  key_name   = var.aws_key_pair_name
  public_key = var.aws_key_pair_public
}

# APPLICATION LOAD BALANCER
resource "aws_alb" "test-alb" {
  name               = "app-ALB"
  security_groups    = [aws_security_group.alb_sg.id]
  #count = length(var.availability_zone)
  #subnets            = [for id in module.network_block.public_subnets_id : id]
  subnets            = module.network_block.public_subnets_id[*]
  #subnets         = aws_subnet.public.*.id

  tags = {
    Name = "app-ALB"
  }
}

resource "aws_alb_target_group" "target_gr_front" {
  name     = "app-target-front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network_block.vpc_id
  target_type = "ip"

  tags = {
    Name = "app-target_front"
  }
}

resource "aws_alb_target_group" "target_gr_back" {
  name     = "app-target-back"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.network_block.vpc_id
  target_type = "ip"

  tags = {
    Name = "app-target_back"
  }
}

resource "aws_alb_listener" "listener_http_front" {
  load_balancer_arn = aws_alb.test-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_gr_front.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "listener_http_back" {
  load_balancer_arn = aws_alb.test-alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_gr_back.arn
    type             = "forward"
  }
}
/* resource "aws_alb_target_group_attachment" "target_gr_attach" {
  count = length(aws_instance.test_server)
  target_group_arn = aws_alb_target_group.target_gr.arn
  target_id = aws_instance.test_server[count.index].id
} */

# IAM ROLE FOR ECS CLUSTER 
resource "aws_iam_role" "ecs_service_role" {
  name               = "app-ecs-service-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

# attach service-role: AmazonEC2ContainerServiceRole and GetParameters
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name = "ecs_service_role_policy"
  role = aws_iam_role.ecs_service_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:${var.region}:${var.account_id}:parameter/app/dns_elb_name"
        }
    ]
}
EOF
}

/* resource "aws_iam_policy" "ecs_service_role" {
  name        = "test_policy"
  description = "ecs_service_role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
} */

# attach service-role: AmazonEC2ContainerServiceRole
resource "aws_iam_role_policy_attachment" "ecs_service_attachment" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "app-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
}

# attach service-role: AmazonECSTaskExecutionRolePolicy and GetParameters
resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
  name = "ecs_task_execution_role_policy"
  role = aws_iam_role.ecs_task_execution_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:${var.region}:${var.account_id}:parameter/app/dns_elb_name"
        }
    ]
}
EOF
}

# attach service-role: AmazonECSTaskExecutionRolePolicy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# PARAMETER STORE
resource "aws_ssm_parameter" "dns" {
  name        = "/app/dns_elb_name"
  description = "DNS name for frontend task"
  type        = "String"
  value       = aws_alb.test-alb.dns_name

  depends_on = [
    aws_alb.test-alb
 ]
}

# ECS CLUSTER
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "app_ecs_cluster"
}

resource "aws_cloudwatch_log_group" "app_frontend" {
  name = "app-log-group-frontend-NEW"
  retention_in_days = 7

  tags = {
    Name = "app-log-group-frontend"
  }
}

resource "aws_cloudwatch_log_group" "app_backend" {
  name = "app-log-group-backend"
  retention_in_days = 7

  tags = {
    Name = "app-log-group-backend"
  }
}

resource "aws_ecs_task_definition" "task_definition_backend" {
  family                = "backend"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  #task_role_arn            = aws_iam_role.ecs_service_role.arn
  network_mode             = "awsvpc"
  cpu       = "256"
  memory    = "512"
  requires_compatibilities = ["FARGATE"]
  container_definitions = <<DEFINITION
[{
    "name": "app_backend",
    "image": "${var.ecr_image_backend}",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "networkMode": "awsvpc",
    "portMappings": [
        {
            "containerPort": 8080,
            "hostPort": 8080,
            "protocol": "tcp"
        }
    ],
    "environment": [
        {
            "name": "spring.datasource.username",
            "value": "${var.POSTGRES_USER}"
        },
        {
            "name": "spring.datasource.password",
            "value": "${var.POSTGRES_PASSWORD}"
        },
        {
            "name": "spring.datasource.url",
            "value": "jdbc:postgresql://${aws_db_instance.db.endpoint}/${var.DB_NAME}"
        }
    ],
    "privileged": false,
    "readonlyRootFilesystem": false,
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.app_backend.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "backend"
        }
    }
 }
]
DEFINITION
}

resource "aws_ecs_task_definition" "task_definition_frontend" {
  family                = "frontend"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  #task_role_arn            = aws_iam_role.ecs_service_role.arn
  network_mode             = "awsvpc"
  cpu       = "256"
  memory    = "512"
  requires_compatibilities = ["FARGATE"]
  depends_on = [
    aws_ssm_parameter.dns
  ]
  container_definitions = <<DEFINITION
[{
    "name": "app_frontend",
    "image": "${var.ecr_image_frontend}",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "networkMode": "awsvpc",
    "portMappings": [
        {
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp"
        }
    ],
    "secrets": [
        {
            "name": "dns_elb_name",
            "valueFrom": "arn:aws:ssm:${var.region}:${var.account_id}:parameter/app/dns_elb_name"
        }
    ],
    "privileged": false,
    "readonlyRootFilesystem": false,
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.app_frontend.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "frontend"
        }
    }
 }
]
DEFINITION
}

resource "aws_ecs_service" "ecs_service_backend" {
  name                = "app_service_backend"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.task_definition_backend.arn
  launch_type         = "FARGATE"
  desired_count       = 2
  scheduling_strategy = "REPLICA"
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = module.network_block.public_subnets_id[*]
    security_groups  = [aws_security_group.ecs_tasks_sg.id, aws_security_group.alb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target_gr_back.arn
    container_name   = "app_backend"
    container_port   = 8080
  }

  depends_on = [aws_alb_listener.listener_http_back]
}

resource "aws_ecs_service" "ecs_service_frontend" {
  name                = "app_service_frontend"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.task_definition_frontend.arn
  launch_type         = "FARGATE"
  desired_count       = 2
  scheduling_strategy = "REPLICA"
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = module.network_block.public_subnets_id[*]
    security_groups  = [aws_security_group.ecs_tasks_sg.id, aws_security_group.alb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target_gr_front.arn
    container_name   = "app_frontend"
    container_port   = 80
  }

  depends_on = [aws_alb_listener.listener_http_front]
}

# RDS DB ( PostgreSQL )
resource "aws_db_instance" "db" {
  db_name              = var.DB_NAME
  identifier               = var.DB_NAME
  #db_subnet_group_name     = "${var.rds_public_subnet_group}"
  db_subnet_group_name     = aws_db_subnet_group.private.name
  engine                   = "postgres"
  engine_version           = "10"
  instance_class           = "db.t3.micro"
  username                 = var.POSTGRES_USER
  password                 = var.POSTGRES_PASSWORD
  port                     = 5432
  publicly_accessible      = false
  #storage_encrypted        = true
  allocated_storage        = 25 # gigabytes
  storage_type             = "gp2"
  vpc_security_group_ids   = [aws_security_group.db.id]
  skip_final_snapshot    = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
}

resource "aws_db_subnet_group" "private" {
  name       = "private"
  subnet_ids = module.network_block.private_subnets_id[*]

  tags = {
    Name = "app-private-subnet-group"
  }
}

resource "aws_security_group" "db" {
  name = "app_db"
  description = "RDS postgres servers"
  vpc_id = module.network_block.vpc_id

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = var.security_group_cidr_blocks
  }

  # Backend
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = var.security_group_cidr_blocks
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.security_group_cidr_blocks
  }
}
