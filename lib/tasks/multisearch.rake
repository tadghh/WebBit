namespace :multisearch do
  task update: :enviroment do
    MultisearchUpdateJob.perform_later
  end
end
