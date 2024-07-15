{
    "Version": "2012-10-17",
    "Statement": [
        %{ if SSO_TEAM_ROLE != "" }
        {
            "Sid": "AllowSETeam",
            "Effect": "Allow",
            "Principal": {
                "AWS": ${SSO_USER_LIST}
            },
            "Action": "sts:AssumeRole"
        }
        %{ else }
        {
            "Sid": "AllowIAMUsers",
            "Effect": "Allow",
            "Principal": { 
                "AWS": ${IAM_USER_LIST}               
            },
            "Action": "sts:AssumeRole"
        }
        %{ endif }
    ]
}