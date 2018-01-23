import axios from 'axios';

class APIClient {
  static getSearchResults(filters, pageNumber, callback) {
    const queryParams = {...filters, page: pageNumber};
    console.log(queryParams);
    axios.get('/providers', {params: queryParams})
        .then(res => {
          const totalRecordCount = res.headers['x-total-record-count'],
              pageNumber = res.headers['x-page-number'],
              pageSize = res.headers['x-page-size'];
          callback(res.data, totalRecordCount, pageNumber, pageSize);

        })
  }

  static getStates(callback) {
    axios.get('/states').then(res => {
      callback(res.data);
    });
  }
}

export default APIClient;