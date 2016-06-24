class ModifyHosts

  @@tmp_dir = "/tmp/sitecomparehosts"
  @@overwrite_all = false
  @@test_host_section = ""

      def add_hosts sites, tpuip


        sites.each do |site|
          @@test_host_section = @@test_host_section + "#{tpuip}\t#{site}\n"
        end

        FileUtils.mkdir_p @@tmp_dir
        status = system("sudo cp /etc/hosts #{@@tmp_dir}/hosts; sudo chmod 666 #{@@tmp_dir}/hosts")
        puts "Here is the first status: #{status}"

        @@test_host_section = "\n##START TEST URLS\n#{@@test_host_section}##END TEST URLS\n"
        content = ""
        mode = true
        File.readlines("#{@@tmp_dir}/hosts").each do |line|
          if line.include?("##START TEST URLS")
            mode = false
          elsif line.include?("##TEST URLS END") && mode == false
            mode = true
          end
          if mode == true
            content = (content + line)
          end
        end
        f = open("#{@@tmp_dir}/hosts", 'w+')
        begin
          content = content + @@test_host_section
          f.write(content)
        ensure
          f.close()
        end

        status = system("sudo cp #{@@tmp_dir}/hosts /etc/hosts;sudo chmod 644 #{@@tmp_dir}/hosts")

      end


  def clear_hosts

    FileUtils.mkdir_p @@tmp_dir
    status = system("sudo cp /etc/hosts #{@@tmp_dir}/hosts; sudo chmod 666 #{@@tmp_dir}/hosts")

    @@overwrite_all = "\n##START TEST URLS\n##END TEST URLS\n"
    content = ""
    mode = true
    File.readlines("#{@@tmp_dir}/hosts").each do |line|
      if line.include?("##START TEST URLS")
        mode = false
      elsif line.include?("##TEST URLS END") && mode == false
        mode = true
      end
      if mode == true
        content = (content + line)
      end
    end
    f = open("#{@@tmp_dir}/hosts", 'w+')
    begin
      content = content + @@overwrite_all
      f.write(content)
    ensure
      f.close()
    end

    status = system("sudo cp #{@@tmp_dir}/hosts /etc/hosts;sudo chmod 644 #{@@tmp_dir}/hosts")
    puts "Successfully cleared the hosts from the /etc/hosts file!"
  end


end