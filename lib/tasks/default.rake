if ENV['RACK_ENV'] != 'production'
  require 'rake/clean'

  CLEAN.include 'log/**'

  task default: [:rubocop, :spec, 'cucumber', :ok]

  task :ok do
    red    = "\e[31m"
    yellow = "\e[33m"
    green  = "\e[32m"
    blue   = "\e[34m"
    purple = "\e[35m"
    bold   = "\e[1m"
    normal = "\e[0m"
    puts '', "#{bold}#{red}*#{yellow}*#{green}*#{blue}*#{purple}* #{green} ALL TESTS PASSED #{purple}*#{blue}*#{green}*#{yellow}*#{red}*#{normal}"
  end
end
