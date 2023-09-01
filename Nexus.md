# STEPS

I had trouble accessing your link so I'm going to try to continue without it.

Here's the converted text in Markdown format:

```markdown
# NEXUS3 INSTALLATION

```bash
sudo apt install openjdk-8-jdk -y

cd /opt
wget https://download.sonatype.com/nexus/3/nexus-3.59.0-01-unix.tar.gz
tar -xvf nexus-3.59.0-01-unix.tar.gz

# Create user nexus

adduser nexus

chown -R nexus:nexus nexus-3.59.0-01/
chown -R nexus:nexus sonatype-work/

vi nexus-3.59.0-01/bin/nexus.rc
in ""  put nexus  --->"nexus"

/opt/nexus-3.59.0-01/bin/nexus start
```

# JENKINS TEMPROARY INSTALLATION

```bash
cd /home/ubuntu

sudo apt install openjdk-11-jdk -y
apt install maven -y

wget  https://get.jenkins.io/war-stable/2.414.1/jenkins.war

java -jar jenkins.war --httpPort=8083
```

## ADD in POM

```xml
<project>
    <!-- ... other project information ... -->
    
    <distributionManagement>
        <repository>
            <id>maven-releases</id>
            <url>NEXUS-URL/repository/maven-releases/</url>
        </repository>
        <snapshotRepository>
            <id>maven-snapshots</id>
            <url>NEXUS-URL/repository/maven-snapshots/</url>
        </snapshotRepository>
    </distributionManagement>

    <!-- ... other project configuration ... -->
</project>
```

# PIPELINE

```groovy
pipeline {
    agent any
    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
    environment{
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('git-checkout') {
            steps {
                git 'https://github.com/jaiswaladi2468/BoardgameListingWebApp.git'
            }
        }

        stage('Code-Compile') {
            steps {
               sh "mvn clean compile"
            }
        }
        
        stage('Unit-Test') {
            steps {
               sh "mvn clean test"
            }
        }
        
        stage('Trivy Scan') {
            steps {
               sh "trivy fs ."
            }
        }
        
        stage('OWASP Dependency Check') {
            steps {
               dependencyCheck additionalArguments: ' --scan ./ ', odcInstallation: 'DC'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Sonar Analysis') {
            steps {
               withSonarQubeEnv('sonar'){
                   sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame \
                   -Dsonar.java.binaries=. \
                   -Dsonar.projectKey=BoardGame '''
               }
            }
        }
        
        stage('Code-Build') {
            steps {
               sh "mvn clean package"
            }
        }
        
        stage('Deploy To Nexus') {
            steps {
               withMaven(globalMavenSettingsConfig: 'e7838703-298a-44a7-b080-a9ac14fa0a5e') {
                    sh "mvn deploy"
               }
            }
        }
    }
}
```

