#!groovy

// imports
import java.util.logging.Logger
import jenkins.model.Jenkins

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()
Logger logger = Logger.getLogger("dsuite/jenkins")

// Number of executors
int executors = System.getenv("JENKINS_NB_EXECUTORS") ?: 0

// Logs
logger.info("Number of executors set to ${executors.toString()}")

// Set the number of executors
jenkins.setNumExecutors(executors)

// save current Jenkins state to disk
jenkins.save()
