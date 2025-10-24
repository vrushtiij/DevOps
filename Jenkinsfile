pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'T053', url: 'https://github.com/vrushtiij/DevOps.git'
            }
        }

        stage('Run MySQL SQL File') {
            steps {
                sh """
                # Run MySQL commands from init.sql
                "C:\\Program Files\\MySQL\\MySQL Server 8.0\\bin\\mysql.exe" -u AryaRai -pArya@2008 Company < "C:\\Users\\Arya Rai\\OneDrive\\Desktop\\DevOps\\db\\init.sql"
                """
            }
        }

        stage('Demo Git Commands') {
            steps {
                sh """
                # Demo Git workflow
                git status
                git add .
                git commit -m "Demo commit from Jenkins pipeline"
                git push origin T053
                """
            }
        }
    }
}
