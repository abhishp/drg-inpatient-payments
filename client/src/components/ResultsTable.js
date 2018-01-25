import React, {Component} from 'react';
import {Col, Table} from "react-bootstrap";
import '../styles/ResultsTable.css'

class ResultsTable extends Component {
  render() {
    return (
        <Col sm={12} xsHidden>
          <Table striped bordered responsive condensed className={"search-results"}>
            <thead>
            <tr>
              <th rowSpan={2} className={"th-line-1"}>#</th>
              <th colSpan={5} className={"th-line-1"}>Provider</th>
              <th rowSpan={2} className={"th-line-1"}>HRR Description</th>
              <th rowSpan={2} className={"th-line-1"}>Total Discharges</th>
              <th rowSpan={2} className={"th-line-1"}>Average Covered Charges</th>
              <th rowSpan={2} className={"th-line-1"}>Average Medicare Payments</th>
              <th rowSpan={2} className={"th-line-1"}>Average Total Payments</th>
            </tr>
            <tr>
              <th className={"th-line-2"}>Name</th>
              <th className={"th-line-2"}>Street Address</th>
              <th className={"th-line-2"}>City</th>
              <th className={"th-line-2"}>State</th>
              <th className={"th-line-2"}>Zip Code</th>
            </tr>
            </thead>
            <tbody>
            {this.props.results.map((result, index) => {
              return <tr className={"search-result"} key={'searchResult' + index}>
                <td>{index + 1}</td>
                <td>{result.providerName}</td>
                <td>{result.providerStreetAddress}</td>
                <td>{result.providerCity}</td>
                <td>{result.providerState}</td>
                <td>{result.providerZipCode}</td>
                <td>{result.hospitalReferralRegionDescription}</td>
                <td>{result.totalDischarges}</td>
                <td>${result.averageCoveredCharges}</td>
                <td>${result.averageMedicarePayments}</td>
                <td>${result.averageTotalPayments}</td>
              </tr>
            })}
            </tbody>
          </Table>
        </Col>
    );
  }
}

export default ResultsTable;