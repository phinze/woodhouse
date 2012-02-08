task :test do
  sh "ocrunner -s macosx10.7 -t WoodhouseTests"
end

task :autotest do
  sh "ocrunner -a -g -s macosx10.7 -t WoodhouseTests"
end

task :build do
  sh "xcodebuild -scheme Release -target Woodhouse"
end

task :package => :build do
  require 'rubygems'
  require 'plist'
  info_plist = Plist::parse_xml('./build/Release/Woodhouse.app/Contents/Info.plist')
  version = info_plist["CFBundleVersion"]
  dmg_filename = "build/Woodhouse-#{version}.dmg"
  sh %Q{
    hdiutil create -ov -fs HFS+ -volname "Woodhouse" -srcfolder "build/Release/Woodhouse.app" "#{dmg_filename}"
  }
  sh %Q{
    ruby tools/sign_update.rb #{dmg_filename} ~/.keys/woodhouse-private.pem
  }
end


task :default => :test
