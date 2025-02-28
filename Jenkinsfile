def cmd_exec(command) {
    return bat(returnStdout: true, script: "${command}").trim()
}
pipeline {
  agent {
    node{
      label 'master'
      customWorkspace "workspace/${env.JOB_NAME}"
    }
  }
  triggers {
    cron 'H/1 15 * * * '
  }
  tools {
  maven 'maven-3.6.3'
  }
  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '5', daysToKeepStr: '30', numToKeepStr: '5'))
  }
  stages {
    stage('Jira-ID Check') {
      steps {
        script {
          echo "To check the Jira story ID"
          }
        }
      }
    stage('Build') {
      steps {
        script {
          sh "mvn -f pom.xml install -DbuildNumber=${BUILD_NUMBER} -DskipTests=false"
          stash includes: '*', name: 'sourceCode'
        }
      }
    }
    stage('Unit Test') {
      steps {
        script {
          sh 'mvn -f pom.xml test -DskipTests=false'
        }
      }
    }
    stage('Sonar-Analysis'){
      steps{
        script {
         sh 'echo "To run the sonar scan"'
         /* unstash 'artifacts'
          def sonarscanner = libraryResource 'sonarscanner.sh'
          withSonarQubeEnv('Sonar') {
            sh sonarscanner
          } */
        }
      }
	}
      stage ('Docker-image-build') {
          steps {
             script {
              sh '''
                docker build -t hello-world
              '''
        }
      }
    }
     stage ('Deploy Docker image') {
          steps {
             script {
              sh '''
                docker run -d --name db -p 8080:8091 -p 8080:8089 hello-world:latest
             '''
				}
			}
		}
    stage('Jacoco Result'){
      steps{
        script {
          sh 'echo "Run the Jacoco result"'
          //unstash 'artifacts'
          //jacoco deltaBranchCoverage: '70', deltaClassCoverage: '100', deltaComplexityCoverage: '70', deltaInstructionCoverage: '70', deltaLineCoverage: '70', deltaMethodCoverage: '70', maximumBranchCoverage: '70', maximumClassCoverage: '100', maximumComplexityCoverage: '70', maximumInstructionCoverage: '70', maximumLineCoverage: '70', maximumMethodCoverage: '70'
      }
    }
  }
  }
  post {
    always {
      cleanWs deleteDirs: true
      dir("${env.WORKSPACE}@tmp") {
        deleteDir()
      }
      emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
        recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
        to: "jayasankar.boddu@gmail.com,${env.BUILD_USER_EMAIL}",
        subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
    }
  }
}
