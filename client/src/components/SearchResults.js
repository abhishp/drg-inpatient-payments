import React, {Component} from 'react';
import {Button, Col, Grid, Row} from "react-bootstrap";
import '../styles/SearchResults.css';
import Paging from './Paging';
import SearchResultsForSmallDevice from "./SearchResultsForSmallDevice";
import ResultsTable from "./ResultsTable";

class SearchResults extends Component {
  constructor(...args) {
    super(...args);

    this.handlePageChange = this.handlePageChange.bind(this);

    this.state = {
      results: this.props.results,
      pageNumber: this.props.pageNumber || 1
    }
  }

  handlePageChange(results, pageNumber) {
    this.setState({results: results, pageNumber: pageNumber});
  }

  renderResults() {
    if (this.state.results.length === 0) return <Row>
      <h3>No Results Found</h3>
    </Row>;
    let results = [];

    let resultsRow = <Row key={"resultsRow"}>
          <ResultsTable results={this.state.results}/>
          <SearchResultsForSmallDevice results={this.state.results}/>
        </Row>,
        paginationRow = <Row key={"paginationRow"}>
          <Paging queryParams={this.props.queryParams} handleChange={this.handlePageChange}
                  pageNumber={this.state.pageNumber}
                  totalRecordCount={this.props.totalRecordCount} pageSize={this.props.pageSize}/>
        </Row>;

    results.push(resultsRow);
    results.push(paginationRow);
    return results;
  }

  render() {
    return (
        <Grid fluid>
          <Row  className={"search-results-header"}>
            <Col xs={2}>
              <Button bsStyle={"link"} onClick={this.props.showSearchForm}>
                &larr; Search
              </Button>
            </Col>
            <Col xs={8}>
              <h2> Search Results</h2>
            </Col>
            <Col xs={2}/>
          </Row>
          {this.renderResults()}
        </Grid>
    )
  }

}

export default SearchResults;