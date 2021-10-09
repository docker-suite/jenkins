#!groovy

// imports
import java.util.logging.Logger
import jenkins.*
import jenkins.model.*
import hudson.model.*

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()
Logger logger = Logger.getLogger("dsuite/jenkins")

logger.info("Disabling the Jenkins CLI...")

// disabled CLI access over TCP listener (separate port)
def p = AgentProtocol.all()
p.each { x ->
    if (x.name?.contains("CLI")) {
        logger.info("Removing protocol ${x.name}")
        p.remove(x)
    }
}

// disable CLI access over /cli URL
def removal = { lst ->
    lst.each { x ->
        if (x.getClass().name.contains("CLIAction")) {
            logger.info("Removing extension ${x.getClass().name}")
            lst.remove(x)
        }
    }
}

removal(jenkins.getExtensionList(RootAction.class))
removal(jenkins.actions)

logger.info("CLI disabled")
