#---------------------------------------------------------------------------------------------------
# Elasticsearch Cluster for On-demand Log Analysis
#---------------------------------------------------------------------------------------------------

locals {
  common_log_es_dedicated_master_count   = "3"
  common_log_es_dedicated_master_enabled = "true"
  common_log_es_dedicated_master_type    = "t2.medium.elasticsearch"
  common_log_es_instance_count           = "4"
  common_log_es_instance_type            = "r4.large.elasticsearch"
  common_log_es_zone_awareness_enabled   = "true"
  common_log_es_volume_type              = "gp2"
  common_log_es_volume_size              = "512"

  subnet_es = {
    "dev" = []
    "prd" = []
  }

  sg_es = {
    "dev" = []
    "prd" = []
  }
}

#---------------------------------------------------------------------------------------------------
# Elasticsearch Cluster
#---------------------------------------------------------------------------------------------------

resource "aws_elasticsearch_domain" "internal-log" {

  domain_name           = "internal-log"
  elasticsearch_version = "5.6"

  cluster_config {
    dedicated_master_count   = "${local.common_log_es_dedicated_master_count}"
    dedicated_master_enabled = "${local.common_log_es_dedicated_master_enabled}"
    dedicated_master_type    = "${local.common_log_es_dedicated_master_type}"
    instance_count           = "${local.common_log_es_instance_count}"
    instance_type            = "${local.common_log_es_instance_type}"
    zone_awareness_enabled   = "${local.common_log_es_zone_awareness_enabled}"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "${local.common_log_es_volume_type}"
    volume_size = "${local.common_log_es_volume_size}"
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "es:*",
            "Resource": "arn:aws:es:${lookup(var.region, terraform.env)}:${lookup(var.account_id, terraform.env)}:domain/internal-log/*"
        }
    ]
}
CONFIG

  vpc_options {
    security_group_ids = "${local.sg_es[terraform.env]}"
    subnet_ids         = "${local.subnet_es[terraform.env]}"
  }

  snapshot_options {
    automated_snapshot_start_hour = 16
  }

  tags {
    Terraform = "true"
  }
}
