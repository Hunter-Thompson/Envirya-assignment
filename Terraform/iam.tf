
resource "aws_iam_role" "s3_role" {
  name = "s3_role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
  ]
} 
EOF
}


resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::test"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::test/*"]
    }
  ]
} 
EOF

}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = [aws_iam_role.s3_role.name]
  policy_arn = aws_iam_policy.policy.arn
}


resource "aws_iam_instance_profile" "s3_profile" {
  name  = "s3_profile"
  role = aws_iam_role.s3_role.name
}