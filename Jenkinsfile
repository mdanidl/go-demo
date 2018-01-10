node {
    def root = tool name: 'Default Go', type: 'go'
    def version=currentBuild.id
    withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin"]) {

        stage('Fetch') { 
            git 'https://github.com/mdanidl/go-demo.git'
         
        }
        stage('Unit Test') {
            sh "go test"

        }
        stage('Build') {
            sh "go build -x -o bin/go-demo"
        }
        stage('Copy Artifacts to S3') {
            withAWS(credentials:'mdaniaws', region: 'eu-west-1') {
                s3Upload(
                    file:'bin/', 
                    bucket:'ecsd-mdanidl', 
                    path:'go-demo/artifacts/'+currentBuild.id+'/',
                    acl: 'PublicRead'
                )
                archive 'bin/*'
            } 
        }
    }

    stage('Deploy To DEV') {
        def tfHome = tool name: 'Default Terraform', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
        env.PATH = "${tfHome}:${env.PATH}"
        // create aws instance
        // ENV: APP_ENV , APP_BGC , APP_VER
        // when done, do curl externalip and check return code
        // eg: this is integration test
        ansiColor('xterm') {
            withAWS(credentials:'mdaniaws', region: 'eu-west-1') {
                sh """
                    cd tf
                    terraform init
                    terraform get
                    terraform apply -var 'aws_region=eu-west-1' -var 'aws_subnet_id=subnet-3166495a' -var 'security_group_ids=["sg-1aee6062","sg-f001cb88"]' -var 'key_name=ForestMain' -var 'version=${version}' -var 'version_colour=grey' -var 'app_env=dev' -state=dev.state -auto-approve                
                """
            }
        }
    }
    sleep(15)
    stage('Integration Test on Dev') {
        def returnCode = sh(
            returnStdout: true,
            script: '''
                curl -s dev.go.mdanidl.ecs.digital:8080 -I | head -n1 | awk '{print $2}'
            '''
        )
        echo returnCode.trim()
        if (true) {
            withAWS(credentials:'mdaniaws', region: 'eu-west-1') {
                sh """
                    cd tf
                    terraform init
                    terraform destroy -var 'aws_region=eu-west-1' -var 'aws_subnet_id=subnet-3166495a' -var 'security_group_ids=["sg-1aee6062","sg-f001cb88"]' -var 'key_name=ForestMain' -var 'version=${version}' -var 'version_colour=grey' -var 'app_env=dev' -state=tf/dev.state -force                
                """
                error("Didn't get HTTP 200. Failing...")
            }
        }
    }

    stage('Deploy To UAT') {
      // create aws instance
      // ENV: APP_ENV , APP_BGC , APP_VER
      // when done, do curl externalip and check if 
    }

    stage('Deploy approval'){
        input "Deploy to PROD?"
    }

    stage('Deploy to PROD') {
      // create aws instance
      // ENV: APP_ENV , APP_BGC , APP_VER
      // when done, do curl externalip and if 
    }


}