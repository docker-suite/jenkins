#!groovy

// imports
import java.util.logging.Logger
import jenkins.model.Jenkins
import jenkins.security.s2m.AdminWhitelistRule

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()
Logger logger = Logger.getLogger("dsuite/jenkins")

logger.info("enabling slave master access control")

//
jenkins.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)

// save current Jenkins state to disk
jenkins.save()
