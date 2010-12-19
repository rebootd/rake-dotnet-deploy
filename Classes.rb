require 'fileutils'
require 'zip/zip'
require 'zip/zipfilesystem'

module Stamp
  def ts
    @stamp ||= Time.now.strftime("%Y%m%d%H%M")
  end
end

module Filez
  def copy(origin, destination)
    return false unless File.exists?(origin)
	
	#puts "destination[#{destination}] exists = " + File.exists?(destination).to_s
	FileUtils.mkdir_p(destination) unless File.exists?(destination)
	
    cmd = "xcopy #{origin}\\* #{destination} /S /Q /Y /Z"
	sh cmd
	true
  end
  
  def compress(path)
    # puts "archive source = #{path}"
    archive = path+'.zip'
	#puts "compressing to #{archive}..."
    FileUtils.rm archive, :force=>true
    Zip::ZipFile.open(archive, 'w') do |zipfile|
      Dir["#{path}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(path+'/',''),file)
      end
    end
  end
end

class SqlBackup
  include Stamp
  attr_accessor :server, :database, :path, :stamp

  def initialize(server, database, path)
    @server = server
	@database = database
	@path = path
  end
  
  def sql_cmd
    backup_query = "BACKUP DATABASE [#{@database}]"
    backup_query << " TO DISK = N'#{@path}#{@server}.#{@database}_backup_#{self.ts}.bak'"
    backup_query << " WITH NOFORMAT, NOINIT, NAME = N'#{@database}-Full Database Backup'"
    backup_query << ", SKIP, NOREWIND, NOUNLOAD, STATS = 10;"
	backup_query
  end
  
  def run_backup
    sh 'sqlcmd -S ' + @server + ' -E -Q "' + self.sql_cmd + '"'
  end
end

class WebBackup
  include Stamp
  include Filez
  
  def backuppath(dest)
    dest + '-' + ts
  end
  
  def backup(origin, destination)
    return false if not File.exists?(origin)
    destination = backuppath(destination)
	#puts "origin=\t#{origin} \ndest=\t#{destination} \n\n"  
	begin
      copy origin, destination
	  true
	rescue Exception=>e
	  false
	end	
  end
end

class WebDeploy < WebBackup
  def deploy(origin, destination, backup)
    backup destination, backup #backup the current version
	copy origin, destination
	webconf = backuppath(backup)+'\\web.config'
	FileUtils.cp webconf, destination if File.exists?(webconf) # restore original web.config
	true
  end
end

class AppState
  attr_accessor :path, :htm_file
  
  def initialize(path)
    @path = path
	@htm_file = File.dirname(__FILE__) + '/app_offline.htm'
  end
  
  def offline
    FileUtils.cp @htm_file, @path
  end
  
  def online
    target = @path + '/app_offline.htm'
    File.delete(target) if File.exists?(target)
  end  
end