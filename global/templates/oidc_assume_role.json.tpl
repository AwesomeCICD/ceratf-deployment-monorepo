{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/oidc.circleci.com/org/${CIRCLECI_ORG_ID}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.circleci.com/org/${CIRCLECI_ORG_ID}:aud": "${CIRCLECI_ORG_ID}"
                }
            }
        },
        {
            "Sid": "AllowSETeam",
            "Effect": "Allow",
            "Principal": {
                "AWS": ${SSO_USER_LIST}
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Sid": "AllowIAMUsers",
            "Effect": "Allow",
            "Condition": {
                "StringLike": {
                "aws:PrincipalArn": "arn:aws:iam::${AWS_ACCOUNT_ID}:role/*_CERA_access"
                }
            },
            "Action": "sts:AssumeRole"
        }
    ]
}