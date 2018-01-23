import React, { Component } from 'react';
import '../styles/App.css';
import SearchForm from './SearchForm';
import SearchResults from "./SearchResults";

class App extends Component {
  constructor(...args) {
    super(...args);

    this.showResults = this.showResults.bind(this);
    this.showSearchForm = this.showSearchForm.bind(this);

    this.state = {
      showSearchForm: true,
      showResults: false,
      queryParams: {
        state: '',
        min_discharges: '',
        max_discharges: '',
        min_average_covered_charges: '',
        max_average_covered_charges: '',
        min_average_medicare_payments: '',
        max_average_medicare_payments: '',
        min_average_total_payments: '',
        max_average_total_payments: ''
      }
    };
  }
  showResults(queryParams, results, totalRecordCount, pageSize) {
    this.setState({
      showResults: true,
      showSearchForm: false,
      queryParams: queryParams,
      results: results,
      totalRecordCount: totalRecordCount,
      pageSize: pageSize
    });
  }

  showSearchForm() {
    console.log('showSearchForm');
    this.setState({...this.state, showSearchForm: true, showResults: false});
  }
  render() {
    let elementToDisplay = null;
    if(this.state.showSearchForm)
      elementToDisplay = <SearchForm showResults={this.showResults} filters={this.state.queryParams} />;
    else if(this.state.showResults)
      elementToDisplay = <SearchResults results={this.state.results} totalRecordCount={this.state.totalRecordCount}
                                        pageSize={this.state.pageSize} queryParams={this.state.queryParams}
                                        showSearchForm={this.showSearchForm}/>;

    return (
      <div className="App">
        <header className="App-header">
          <h1 className="App-title">DRG Inpatient Payments</h1>
        </header>
        {elementToDisplay}
      </div>
    );
  }
}

export default App;
