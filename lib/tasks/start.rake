namespace :start do
  task :development do
    exec 'cd client && foreman start -f Procfile'
  end

  desc 'Start production server'
  task :production do
    exec 'NPM_CONFIG_PRODUCTION=true npm run clientbuild && cd client'
  end
end

desc 'Start development server'
task :start => 'start:development'