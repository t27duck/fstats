module Fstats
  class Page
    attr_reader :report

    def initialize(report)
      @report = report
    end

    def get_binding
      binding
    end

    def template
      <<-html
      <html>
      <head>
      <title>Fbombmetrics</title>
      <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
      <script type="text/javascript" src="http://code.highcharts.com/2.2.5/highcharts.js"></script>
      </head>
      <body>
      #{body}
      </body>
      </html>
      html
    end

    def body
      %q{
      



      </body>
      </html>
      }
    end

    def body2
      html = <<-html
      <h2>Top Users</h2>
      <table>
        <thead><tr><th>Name</th><th>Total</th></thead>
        <tbody>
      html
      report.top_users.each do |u|
        html += "<tr><td>#{u[:name]}</td><td>#{u[:total]}</td></tr>"
      end
      html += <<-html
        </tbody>
      </table> 
      <div id="total-by-user"></div>
      #{total_by_user_js}
      <div id="total-by-day"></div>
      #{total_by_date_js}
      html
      html
    end
    
    def footer
      <<-html
      </body>
      </html>
      html
    end

    private ####################################################################

    def total_by_user_js
      html = <<-html
      <script type"text/javascript">
      var total_by_user;
      $(document).ready(function() {
        total_by_user = new Highcharts.Chart({
          chart: {
            renderTo: 'total-by-user',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
          },
          title: {text: 'Total Usage by User'},
          tooltip: {
            formatter: function() {
              return '<b>'+ this.point.name +'</b>: '+ this.y +' ('+ this.percentage.toFixed(2) +'%)';
            }
          },
          
          series: [{
            type: 'pie',
            name: 'User Total',
            data: [
          html
          html += report.total_by_user.map{|x| "['#{x[:name]}',#{x[:total]}]"}.join(",")
          html += <<-html
             ]
          }]
        });
      });
      </script>
      html
      html
    end

    def total_by_date_js
      <<-html
      <script type="text/javascript">
        var total_by_day;
        $(document).ready(function(){
          total_by_day = new Highcharts.Chart({
            chart: {renderTo: 'total-by-day', type: 'column'},
            title: {text: "Usage by day" },
            xAxis: {
              categories: ["#{report.total_by_date.map{|x| x[:date]}.join('","')}"],
              labels: {enabled: false},
              title: {text: "Date"}
            },
            yAxis: {
              title: "Usage", 
              min: 0,
              title: {text: "Total"}
            },
            legend: {enabled: false},
            series: [{data: [#{report.total_by_date.map{|x| x[:total]}.join(",")}]}],
          });
        });
      </script>
      html
    end
  end
end
