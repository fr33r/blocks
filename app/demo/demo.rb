require 'csv'

class Demo
  def run
    puts "Creating file formats:"
    results = create_formats!
    puts "done!"
    puts "Creating files:"
    create_files!(results)
  end

  private

  def create_employees_file!(file_format_id)
    path = Rails.root.join("app", "demo", "employees.csv")
    contents = CSV.read(path, headers: true)
    line_count = contents.count
    conn = new_conn
    body = 
      {
        filename: "employees.csv",
        total_row_count: line_count,
      }.to_json

    file_response = conn.post("/api/formats/#{file_format_id}/files") do |request|
      request.body = body
    end
    file_id = JSON.parse(file_response.body)['id']
    contents.each_with_index do |row, idx|
      row_data = row.to_h
      body = {
        row_number: idx+1,
        data: row_data,
      }.to_json
      conn = new_conn
      row_response = conn.post("/api/formats/#{file_format_id}/files/#{file_id}/rows") do |request|
        request.body = body
      end
    end
    file_response
  end

  def create_computers_file!(file_format_id)
    path = Rails.root.join("app", "demo", "computers.csv")
    contents = CSV.read(path, headers: true)
    line_count = contents.count
    conn = new_conn
    body = 
      {
        filename: "computers.csv",
        total_row_count: line_count,
      }.to_json

    file_response = conn.post("/api/formats/#{file_format_id}/files") do |request|
      request.body = body
    end
    file_id = JSON.parse(file_response.body)['id']
    contents.each_with_index do |row, idx|
      row_data = row.to_h
      body = {
        row_number: idx+1,
        data: row_data,
      }.to_json
      conn = new_conn
      row_response = conn.post("/api/formats/#{file_format_id}/files/#{file_id}/rows") do |request|
        request.body = body
      end
    end
    file_response
  end

  def create_companies_file!(file_format_id)
    path = Rails.root.join("app", "demo", "companies.csv")
    contents = CSV.read(path, headers: true)
    line_count = contents.count
    conn = new_conn
    body = 
      {
        filename: "companies.csv",
        total_row_count: line_count,
      }.to_json

    file_response = conn.post("/api/formats/#{file_format_id}/files") do |request|
      request.body = body
    end
    file_id = JSON.parse(file_response.body)['id']
    contents.each_with_index do |row, idx|
      row_data = row.to_h
      body = {
        row_number: idx+1,
        data: row_data,
      }.to_json
      conn = new_conn
      row_response = conn.post("/api/formats/#{file_format_id}/files/#{file_id}/rows") do |request|
        request.body = body
      end
    end
    file_response
  end

  def create_files!(results)
    employees_response = create_employees_file!(results.fetch(:employees_format_id))
    print_status(employees_response)
    companies_response = create_companies_file!(results.fetch(:companies_format_id))
    print_status(companies_response)
    computers_response = create_computers_file!(results.fetch(:computers_format_id))
    print_status(computers_response)
  end

  def print_status(response)
    response.status == 201 ? puts("\t✅") : puts("\t❌")
  end

  def create_formats!
    employees_response = create_employees_file_format!
    print_status(employees_response)
    companies_response = create_companies_file_format!
    print_status(companies_response)
    computers_response = create_computers_file_format!
    print_status(computers_response)
    {
      employees_format_id: JSON.parse(employees_response.body)['id'],
      companies_format_id: JSON.parse(companies_response.body)['id'],
      computers_format_id: JSON.parse(computers_response.body)['id'],
    }
  end

  def new_conn
    Faraday.new(
      url: 'http://localhost:3000',
      headers: {'Content-Type' => 'application/json'},
    )
  end

  def create_employees_file_format!
    conn = new_conn
    body = 
      {
        name: "EMPLOYEES",
        description: "Employee list for all companies.",
        columns: [{
          name: "FIRST_NAME",
          description: "The first name of the employee.",
          required: true,
          data_type: "string"
        },{
          name: "LAST_NAME",
          description: "The last name (surname) of the employee.",
          required: true,
          data_type: "string"
        },{
          name: "COMPANY_ID",
          description: "The ID of the company that employees the employee.",
          required: true,
          data_type: "integer"
        },{
          name: "ROLE",
          description: "The job title of the employee.",
          required: false,
          data_type: "string"
        },{
          name: "STARTED_AT",
          description: "The date the employee started working at the company.",
          required: true,
          data_type: "date"
        }],
        anchors: [{
          name: "Full name",
          description: "Joins files based on the first and last name of the employee.",
          columns: [ "FIRST_NAME", "LAST_NAME" ]
        },{
          name: "Company ID",
          description: "Joins files based on the company ID.",
          columns: [ "COMPANY_ID" ]
        }]
      }.to_json

    conn.post('/api/formats') do |request|
      request.body = body
    end
  end

  def create_companies_file_format!
    conn = new_conn
    body = 
      {
        name: "COMPANIES",
        description: "Directory of all companies.",
        columns: [{
          name: "ID",
          description: "The ID of the company.",
          required: true,
          data_type: "integer"
        },{
          name: "NAME",
          description: "The name of the company.",
          required: true,
          data_type: "string"
        },{
          name: "ADDRESS",
          description: "The full address of the company headquarters.",
          required: false,
          data_type: "string"
        }],
        anchors: [{
          name: "Company ID",
          description: "Joins files based on the company ID.",
          columns: [ "ID" ]
        }]
      }.to_json

    conn.post('/api/formats') do |request|
      request.body = body
    end
  end

  def create_computers_file_format!
    conn = new_conn
    body = 
      {
        name: "COMPUTERS",
        description: "Computer equipment list for all employees.",
        columns: [{
          name: "FIRST_NAME",
          description: "The first name of the employee.",
          required: true,
          data_type: "string"
        },{
          name: "LAST_NAME",
          description: "The last name (surname) of the employee.",
          required: true,
          data_type: "string"
        },{
          name: "COMPUTER_MAKE",
          description: "The brand of the computer.",
          required: true,
          data_type: "string"
        },{
          name: "OS",
          description: "The operating system of the computer.",
          required: true,
          data_type: "string"
        },{
          name: "OS_VERSION",
          description: "The version of the operating system.",
          required: true,
          data_type: "string"
        }],
        anchors: [{
          name: "Full name",
          description: "Joins files based on the first and last name of the employee.",
          columns: [ "FIRST_NAME", "LAST_NAME" ]
        }]
      }.to_json

    conn.post('/api/formats') do |request|
      request.body = body
    end
  end
end
