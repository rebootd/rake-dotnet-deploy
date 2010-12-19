# ------------------------------------------------------------------------------------------------------
# AUTHOR: Josh Coffman
# PURPOSE: Automate deployment including backup of files and database
#
# DEPENDENCIES: run check-deps.bat to ensure Ruby 1.9.2 and required gems are installed. This bat file
#				will be run when you execute either of the deployment bat file to ensure it can complete
# ------------------------------------------------------------------------------------------------------

require 'rubygems'
require 'fileutils'
require 'albacore'
require './Classes'
require './Const'

task :default do
  puts "rake [target]\n\n"
  puts "targets are..."
  puts "\t:default \t\t this task"
  puts "\t:compile \t\t builds #{PROJ_NAME}.sln"
  puts "\t:build \t\t\t builds #{PROJ_NAME}.sln"
  puts "\t:devdeploy \t\t deploys local build to dev"
  puts "\t:proddeploy \t\t deploys dev build to production"
  puts "\t:backup_local_sql \t backs up #{LOCAL_SQL}.#{LOCAL_DB} database"
  puts "\t:backup_dev_sql \t backs up #{DEV_SQL}.#{DEV_DB} database"
  puts "\t:backup_prod_sql \t backs up #{PROD_SQL}.#{PROD_DB} database"

  puts ""
end

task :compile => [:build]

task :clean do
  FileUtils.rm_rf OUTPUT
end

task :notimplemented do
  puts "\nnot implemented\n\n"
end

#---- util methods ----#
#----------------------#
def deployit(origin, dest, backup)
  puts 'starting deployment...'
  app = AppState.new(dest)
  app.offline
  puts 'deployment FAILED' and return false if not WebDeploy.new.deploy(origin, dest, backup)  
  app.online
  puts 'DONE'
  true
end

def backitup(source, backup)
  puts 'starting backup...'
  puts 'backup FAILED' and return false if not WebBackup.new.backup(source, backup)
  # compressit backup
  puts 'done'
  true
end

def compressit(source)
  puts 'starting zip...'
  puts 'zip FAILED' and return false if not WebBackup.new.compress(source)
  puts 'zip completed'
  true
end

#---- test tasks ----#
#--------------------#
task :archpath do
  puts LOCAL_COPY
  puts "dir = " + File.directory?(LOCAL_COPY).to_s
end

task :testbackup do
  backitup LOCAL_COPY, LOCAL_BACKUP
end

task :testdeploy do
  deployit LOCAL_OUTPUT, LOCAL_COPY, LOCAL_BACKUP
end

task :testcompress do
  compressit LOCAL_COPY
end

task :testoffline do
  dest = LOCAL_PATH
  app = AppState.new(dest)
  app.offline
end

task :testonline do
  dest = LOCAL_PATH
  app = AppState.new(dest)
  app.online
end

#---- deploy tasks ----#
#----------------------#
task :devdeploy => [:clean, :build, :backup_dev_sql, :deploy_dev_web]
task :proddeploy => [:backup_prod_sql, :deploy_prod_web]

task :deploy_dev_web do
  deployit LOCAL_OUTPUT, DEVPORTAL_DEST, DEVPORTAL_BACKUP
end

task :deploy_prod_web do
  deployit DEVPORTAL_DEST, PORTAL_DEST, PORTAL_BACKUP
end

#---- web backup tasks ----#
#--------------------------#
task :backup_dev_web do
  backitup DEVPORTAL_DEST, DEVPORTAL_BACKUP
end

task :backup_prod_web do
  backitup PORTAL_DEST, PORTAL_BACKUP
end

#---- sql backup tasks ----#
#--------------------------#
task :backup_local_sql do
  puts 'running backup..'
  backup = SqlBackup.new(LOCAL_SQL, LOCAL_DB, LOCAL_SQL_BACKUP)
  backup.run_backup
  puts 'complete.'
end

task :backup_dev_sql do
  puts 'running backup..'
  backup = SqlBackup.new(DEV_SQL, DEV_DB, DEV_SQL_BACKUP)
  backup.run_backup
  puts 'complete.'
end

task :backup_prod_sql do
  puts 'running backup..'
  backup = SqlBackup.new(PROD_SQL, PROD_DB, PROD_SQL_BACKUP)
  backup.run_backup
  puts 'complete.'
end

#---- compile/build tasks ----#
#-----------------------------#
msbuild :build do |msb|
  msb.solution = SLN_FILE
  msb.targets :clean, :build
  msb.properties :configuration => :debug, :outdir => OUTPUT
  msb.verbosity = 'quiet'
end
