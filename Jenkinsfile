node {
    def root = tool name: 'Default Go', type: 'go'
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
                s3Upload(file:'bin/', bucket:'ecsd-mdanidl', path:'go-demo/artifacts/'+currentBuild.id+'/')
                archive 'bin/*'
            } 
        }
    }

    stage('Deploy To DEV') {

    }

    stage('Deploy To UAT') {

    }

    stage('Deploy approval'){
        input "Deploy to prod?"
    }

    stage('Deploy to PROD') {

    }


}