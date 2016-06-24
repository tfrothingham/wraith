require 'fileutils'
class Archive


  def archive (sites, archive)

    basedir = File.join(Dir.pwd, '/UICompare')
    archivebasedir = File.join(basedir, '/archive')

    puts "base dir: " + basedir
    if archive =='latest'
      archive = 'current'
    end

    sites.each do |site|

      begin
        filemeta = File.mtime(File.join(basedir, "/#{archive}/#{site}"))
        year = filemeta.strftime('%Y').to_s
        month = filemeta.strftime('%b').to_s
        day = filemeta.strftime('%a').to_s
        time = filemeta.strftime('_%I_%M').to_s

        pathPart = year.to_s + '/' + month + '/' + archive + '/' + site + '/' + day + time
        sitePath = File.join(archivebasedir, pathPart)

        FileUtils.mkdir_p(sitePath) unless File.exists?(sitePath)

        FileUtils.move(File.join(File.join(basedir, "/#{archive}"), site), sitePath)

          #catch the file not found and drop it on the floor, dont need to archive if there is no file
      rescue
        next
      end

    end
    if archive == 'current'
      FileUtils.rm_rf(File.join(basedir, "/#{archive}/*"))
    end
  end

end





