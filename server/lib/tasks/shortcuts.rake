desc "Generate the index."
task :index => :application do
  Rake::Task[:'index:generate'].invoke
end

desc "Try the given text in the indexer/query (type:field optional)."
task :try, [:text, :type_and_field] => :application do |_, options|
  text, type_and_field = options.text, options.type_and_field
  
  Rake::Task[:'try:both'].invoke text, type_and_field
end

desc "Start the server."
task :start do
  Rake::Task[:'server:start'].invoke
end
desc "Stop the server."
task :stop do
  Rake::Task[:'server:stop'].invoke
end