task :test do
  sh "ocrunner -s macosx10.7 -t WoodhouseTests"
end

task :autotest do
  sh "ocrunner -a -g -s macosx10.7 -t WoodhouseTests"
end

task :package do
  sh 'hdiutil create -ov -fs HFS+ -volname "Woodhouse" -srcfolder "build/Release/Woodhouse.app" "build/Woodhouse.dmg"'
end


task :default => :test
