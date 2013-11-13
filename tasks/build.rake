namespace :build do
  def generate_reports_page
    index_page_content = <<-index_page
      <html>
        <head>
          <title>Build Reports Page</title>
        </head>
        <body>
          <ul>
            <li><a href="lint.html">Puppet Lint Report</a></li>
            <li><a href="unit.spec.html">Unit Tests Report</a></li>
            <li><a href="system.spec.html">Integration Tests Report</a></li>
          </ul>
        </body>
      </html>
    index_page

    FileUtils.mkdir_p('reports')
    File.open("reports/index.html", 'w') { |file| file.write(index_page_content) }
  end

  desc 'Generate a module artifact for distribution'
  task :package do
    verbose(false) do
      sh 'bundle exec puppet module build .'
    end
  end

  desc 'Clean build data (e.g. deletes pkg and reports directories)'
  task :clean do
    FileUtils.rm_rf(['pkg', 'reports'])
  end

  desc 'Builds the module running all tests, lint and generating report files and the module artifact'
  task :run => :clean do
    generate_reports_page
    verbose(false) do
      sh 'bundle exec rake lint > reports/lint.html'
      sh 'bundle exec rake spec:ci > reports/unit.spec.html'
      sh 'bundle exec rake build:package'
    end
  end
end
