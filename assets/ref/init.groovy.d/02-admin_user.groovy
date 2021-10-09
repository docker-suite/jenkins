#!groovy

// imports
import java.util.logging.Logger
import java.lang.StringBuilder
import jenkins.model.Jenkins
import hudson.model.*
import hudson.security.*
import hudson.security.csrf.DefaultCrumbIssuer

// This script should be run only once
// So if the file exist, just ignore this script
File disableScript = new File(Jenkins.get().getRootDir(), ".disable-create-admin-user")
if (disableScript.exists()) {
    return
}

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()
Logger logger = Logger.getLogger("dsuite/jenkins")
String newLine = System.getProperty("line.separator");

// User authentication
HudsonPrivateSecurityRealm hudsonRealm = new HudsonPrivateSecurityRealm(false)

// User authorization
GlobalMatrixAuthorizationStrategy matrixStrategy = new GlobalMatrixAuthorizationStrategy()

// Get or create admin password
String adminPassword = System.getenv("JENKINS_ADMIN_PASSWORD") ?: UUID.randomUUID().toString().replaceAll("-", "")

// admin user
hudsonRealm.createAccount('admin', adminPassword)
new File('/var/jenkins_home/secrets/initialAdminPassword').append(
    new StringBuilder().append("${adminPassword}").append(newLine)
)
logger.info(new StringBuilder().append(newLine)
    .append(newLine)
    .append("*************************************************************").append(newLine)
    .append(newLine)
    .append("An admin user has been created.").append(newLine)
    .append("Please use the following password:").append(newLine)
    .append(newLine)
    .append("${adminPassword}").append(newLine)
    .append(newLine)
    .append("This may also be found at: /var/jenkins_home/secrets/initialAdminPassword").append(newLine)
    .append(newLine)
    .append("*************************************************************").append(newLine)
    .toString()
)
matrixStrategy.add(Jenkins.ADMINISTER, "admin")

// jenkins user
hudsonRealm.createAccount('jenkins', adminPassword)
new File('/var/jenkins_home/secrets/initialJenkinsPassword').append(
    new StringBuilder().append("${adminPassword}").append(newLine)
)
logger.info(new StringBuilder().append(newLine)
    .append(newLine)
    .append("*************************************************************").append(newLine)
    .append(newLine)
    .append("A jenkins user has been created.").append(newLine)
    .append("Please use the following password:").append(newLine)
    .append(newLine)
    .append("${adminPassword}").append(newLine)
    .append(newLine)
    .append("This may also be found at: /var/jenkins_home/secrets/initialJenkinsPassword").append(newLine)
    .append(newLine)
    .append("*************************************************************").append(newLine)
    .toString()
)
matrixStrategy.add(Jenkins.ADMINISTER, "jenkins")

// Authenticated user
matrixStrategy.add(Jenkins.READ,'authenticated')
matrixStrategy.add(Item.READ,'authenticated')
matrixStrategy.add(Item.DISCOVER,'authenticated')
matrixStrategy.add(Item.CANCEL,'authenticated')
matrixStrategy.add(Item.READ,'anonymous')

// Apply
jenkins.setSecurityRealm(hudsonRealm)
jenkins.setAuthorizationStrategy(matrixStrategy)
jenkins.save()

// Crete the file to prevent further initialisation
disableScript.createNewFile()
