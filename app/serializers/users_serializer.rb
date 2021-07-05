class UsersSerializer < Blueprinter::Base
  identifier :name

  view :extended do
    field :id
  end
end
