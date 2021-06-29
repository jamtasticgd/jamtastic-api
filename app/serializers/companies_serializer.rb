class CompaniesSerializer < Blueprinter::Base
  identifier :name

  fields :email, :facebook, :twitter, :url, :logo, :created_at, :updated_at
end
