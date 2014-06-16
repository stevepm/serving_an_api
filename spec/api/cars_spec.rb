require 'rails_helper'

describe 'Car API' do

  describe 'GET /cars' do
    it 'returns a list of cars' do
      ford = create_make(:name=> "Ford")
      chevy = create_make(:name=> "Chevy")
      blue_four_door = create_car(:color => "blue",
                                  :doors => 4,
                                  :purchased_on=> "2013-01-01",
                                  :make=> ford)
      green_two_door = create_car(:color=> "green",
                                  :doors=> 2,
                                  :purchased_on=> "1991-02-02",
                                  :make=> chevy)

      get '/cars',{}, {'Accept' => 'application/json'}

      expected_response = {
        "_links"=> {
          "self"=> {
            "href"=> "/cars"
          }
        },
        "_embedded"=> {
          "cars"=> [
            {
              "_links"=> {
                "self"=> {
                  "href"=> "/cars/#{blue_four_door.id}"
                },
                "make"=> {
                  "href"=> "/makes/#{ford.id}"
                }
              },
              "id"=> blue_four_door.id,
              "color"=> "blue",
              "doors"=> 4,
              "purchased_on"=> "2013-01-01T00:00:00.000Z"
            },
            {
              "_links"=> {
                "self"=> {
                  "href"=> "/cars/#{green_two_door.id}"
                },
                "make"=> {
                  "href"=> "/makes/#{chevy.id}"
                }
              },
              "id"=> green_two_door.id,
              "color"=> "green",
              "doors"=> 2,
              "purchased_on"=> "1991-02-02T00:00:00.000Z"
            }
          ]
        }
      }

      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq(expected_response)

    end
  end

end
