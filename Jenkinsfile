pipeline {
    agent any

    environment {
        DEPLOY_EMAIL = 'srengty@gmail.com'
    }

    options {
        skipDefaultCheckout()
        timestamps()
    }

    triggers {
        pollSCM('H/5 * * * *') // Poll Git every 5 mins
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-dev'
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'php artisan test'
            }
        }

        stage('Deploy with Ansible') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                sh 'ansible-playbook -i inventory.ini ansible-playbook.yml'
            }
        }
        stage('Break It') {
    steps {
        sh 'exit 1'
    }
}

    }

 post {
    failure {
        emailext(
            subject: "❌ Build Failed: ${env.JOB_NAME} [#${env.BUILD_NUMBER}]",
            body: """Build failed! 😬  
Check Jenkins here: ${env.BUILD_URL}""",
            recipientProviders: [developers(), requestor()],
            to: 'srengty@gmail.com'
        )
    }
}

}
