import jenkins.model.*
import javaposse.jobdsl.plugin.ExecuteDslScripts
import javaposse.jobdsl.plugin.MultiplePluginConfiguration

def instance = Jenkins.getInstance()
println("DevSecOps: Init script ensuring Job DSL seed is executed - please run seed job via Job DSL plugin or Job DSL seed job.")
