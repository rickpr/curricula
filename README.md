# Curricula

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'curricula'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install curricula

## Usage

First, create your excel spreadsheet with the following format (NO HEADER). This
is two things in a single worksheet, this may be worked out later, but for now,
do this. Here's an example to get you going (leave out the header):

|Course|Prereq?|Hours|
|:----:|:-----:|:---:|
|MATH 162| |4|
|MATH 163| |4|
|MATH 264| |3|
|MATH 162|prereq|MATH 162|
|MATH 163|prereq|MATH 264|

Add an Excel spreadsheet to this:

```ruby
my_plan = Curricula::DegreePlan.new "worksheet.xls"
```

Then, compute the efficiency. Lower is better:

```ruby
my_plan.efficiency
```

If you need a list of courses (as a hash), use `course_list`:

```ruby
my_plan.course_list
```

To use this as part of a graph, use the following two methods:

```ruby
my_plan.graph_nodes
my_plan.graph_edges
```

`graph_nodes` returns a list of strings, `graph_edges` returns a hash of edges,
with `:source` and `:destination` to mark the directionality of the
prerequisites.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/curricula/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
