f = ChefGen::Flavor::Awesome.new(
  type: 'cookbook', recipe: self
)

f.class.after_declare_resources do
  self.next_steps = <<END

go forth and conquer

END
end

f.declare_resources
