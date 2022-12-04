import Foundation
import Alamofire
import ObjectMapper

struct DataParser {
  func mapperParser<T: Mappable>(url: URL,
                                 method: HTTPMethod,
                                 parameters: Parameters,
                                 headers: [String:String] = [:],
                                 completion: @escaping ((Response<T>) -> Void)) {
    do {
      var request = try URLRequest(url: url, method: method)
      request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
      
      Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        .responseJSON() { data in
        let statusCode = data.response?.statusCode
        
        switch data.result {
        case .success(let value):
          if statusCode == 200 {
            guard let item = value as? [String:Any] else { return }
                    
            let model = Mapper<T>().map(JSON: item)
            completion(.success(model: model!))
            
            print(item)
                    
//            for item in value as! [[String:Any]] {
//              let model = Mapper<T>().map(JSON: item)
//              completion(.success(model: model!))
//            }
          }
        case .failure(let error):
          print("Ocorreu o seguinte erro na requisição: ", error)
        }
      }
    } catch let errorData {
      print(errorData)
    }
  }
  
  func encoderParser<T: Decodable>(parameters: Parameters, url: URL, method: HTTPMethod, completion: @escaping ((Result<T, ErrorType>, Int) -> Void)) {
    do {
      var request = try URLRequest(url: url, method: method)
      request.setValue("username", forHTTPHeaderField: "HMG.IOS")
      request.setValue("password", forHTTPHeaderField: "eQtlC7BM")
      request.setValue("grant_type", forHTTPHeaderField: "password")
      
      let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
      request.httpBody = jsonData
      
      Alamofire.request(request).response { (response) in
        guard let statusCode = response.response?.statusCode,
              let data = response.data else {
          return
        }
        
        print("@! >>> STATUS_CODE: ", statusCode)
        
        if statusCode == 200 {
          if let dataResponse = try? JSONDecoder().decode(T.self, from: data) {
            completion(.success(dataResponse), statusCode)
            return
          } else {
            completion(.failure(.errorAPI(error: "")), statusCode)
            return
          }
        } else {
          self.responseFailure(data: data, statusCode: statusCode, completion: completion)
        }
      }
    } catch {
      completion(.failure(.errorAPI(error: "")), 500)
    }
  }
  
  func decoderParser<T: Decodable>(url: URL,
                                   method: HTTPMethod,
                                   parameters: Parameters,
                                   completion: @escaping ((Result<T, ErrorType>, Int) -> Void)) {
    do {
      var request = try URLRequest(url: url, method: method)
      request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
      
      Alamofire.request(request).response { (response) in
        let statusCode = response.response?.statusCode
        guard let data = response.data else { return }
        
        if statusCode == 200 {
          if let dataResponse = try? JSONDecoder().decode(T.self, from: data) {
            completion(.success(dataResponse), 200)
            return
          } else {
            completion(.failure(.errorAPI(error: "")), 500)
            return
          }
        } else {
          self.responseFailure(data: data, statusCode: statusCode ?? 500, completion: completion)
        }
      }
    } catch let errorData {
      completion(.failure(.errorAPI(error: "\(errorData)")), 500)
    }
  }
  
  func responseFailure<T: Decodable>(data: Data,
                                     message: String = "",
                                     statusCode: Int,
                                     completion: @escaping ((Result<T, ErrorType>, Int) -> Void)) {
    if let errorResponse = try? JSONDecoder().decode(Array<ErrorResponse>.self, from: data) {
      let error = errorResponse[0].message ?? ""
      return
    } else {
      completion(.failure(.errorAPI(error: "")), 500)
      return
    }
  }
}

