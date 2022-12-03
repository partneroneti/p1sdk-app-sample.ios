import Foundation
import Alamofire
import ObjectMapper

struct DataParser {
  func mapperParser<T: Mappable>(url: URL,
                                 method: HTTPMethod,
                                 completion: @escaping ((Response<T>) -> Void)) {
    do {
      var request = try URLRequest(url: url, method: method)
      request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
      
      let header = ["Authorization": "Bearer " + ""]
      
      Alamofire.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: header)
        .validate()
        .responseJSON() { data in
        let statusCode = data.response?.statusCode
        
        switch data.result {
        case .success(let value):
          if statusCode == 200 {
            for item in value as! [[String:Any]] {
              let model = Mapper<T>().map(JSON: item)
              completion(.success(model: model!))
            }
          }
        case .failure(let error):
          print("Ocorreu o seguinte erro na requisição: ", error)
        }
      }
    } catch let errorData {
      print(errorData)
    }
  }
  
  func decoderParser<T: Decodable>(url: URL,
                                   method: HTTPMethod,
                                   completion: @escaping ((Result<T, ErrorType>) -> Void)) {
    do {
      var request = try URLRequest(url: url, method: method)
      request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
      
      Alamofire.request(request).response { (response) in
        let statusCode = response.response?.statusCode
        guard let data = response.data else { return }
        
        if statusCode == 200 {
          if let dataResponse = try? JSONDecoder().decode(T.self, from: data) {
            completion(.success(dataResponse))
            return
          } else {
            completion(.failure(.errorAPI(error: "")))
            return
          }
        } else {
          self.responseFailure(data: data, statusCode: statusCode ?? 500, completion: completion)
        }
      }
    } catch {
      completion(.failure(.errorAPI(error: "")))
    }
  }
  
  func responseFailure<T: Decodable>(data: Data,
                                     message: String = "",
                                     statusCode: Int,
                                     completion: @escaping ((Result<T, ErrorType>) -> Void)) {
    if let errorResponse = try? JSONDecoder().decode(Array<ErrorResponse>.self, from: data) {
      let error = errorResponse[0].message ?? ""
      return
    } else {
      completion(.failure(.errorAPI(error: "")))
      return
    }
  }
}

