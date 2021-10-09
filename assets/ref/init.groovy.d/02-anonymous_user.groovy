#!groovy

// imports
import java.util.logging.Logger
import jenkins.model.Jenkins
import hudson.security.*

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()
Logger logger = Logger.getLogger("dsuite/jenkins")

// Logs
logger.info("Remove read access to anonymous users")

// Remove read access to anonymous users
def fullControlStrategy = new FullControlOnceLoggedInAuthorizationStrategy()
fullControlStrategy.setAllowAnonymousRead(false)
jenkins.setAuthorizationStrategy(fullControlStrategy)

// save current Jenkins state to disk
jenkins.save()


