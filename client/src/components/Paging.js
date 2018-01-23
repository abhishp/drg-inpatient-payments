import React, {Component} from 'react';
import {Pager} from "react-bootstrap";
import APIClient from "../APIClient";
import "../styles/Paging.css";

class Paging extends Component {
  constructor(...args) {
    super(...args);

    this.totalPages = Math.floor(this.props.totalRecordCount / this.props.pageSize) + 1;

    this.renderPageItem = this.renderPageItem.bind(this);
    this.setPage = this.setPage.bind(this);
  }

  setPage(page) {
    console.log('page:', page);
    if(this.isCurrentPage(page)) return;

    APIClient.getSearchResults(this.props.queryParams, page, (results, _, pageNumber) => {
      this.props.handleChange(results, pageNumber);
    });
  }

  renderPages() {
    let delta = 2, pages = [], pagesWithEllipsis = [], last;

    pages.push(1);
    for (let page = this.currentPageNumber - delta; page <= this.currentPageNumber + delta; page++) {
      if (page < this.totalPages && page > 1) {
        pages.push(page);
      }
    }
    pages.push(this.totalPages);

    for (let page of pages) {
      page = Number.parseInt(page, 10);
      if (last) {
        if (page - last === 2) {
          pagesWithEllipsis.push(this.renderPageItem(last + 1));
        } else if (page - last !== 1) {
          pagesWithEllipsis.push(Paging.renderEllipsis(pagesWithEllipsis.length));
        }
      }
      pagesWithEllipsis.push(this.renderPageItem(page));
      last = page;
    }

    return pagesWithEllipsis;
  }

  isCurrentPage(pageNumber) {
    return pageNumber === this.currentPageNumber;
  }

  static renderEllipsis(position) {
    return <Pager.Item key={"paginationEllipsis" + position} disabled>&hellip;</Pager.Item>;
  }

  renderPageItem(pageNumber) {
    let isCurrentPage = this.isCurrentPage(pageNumber);
    return <Pager.Item key={"paginationPageItem" + pageNumber} eventKey={pageNumber}
                       className={isCurrentPage && "active-page"}>{pageNumber}</Pager.Item>
  }

  isOnFirstPage() {
    return this.currentPageNumber === 1;
  }

  isOnLastPage() {
    return this.currentPageNumber === this.totalPages;
  }

  renderFirstPageItem() {
    return <Pager.Item key={"paginationFirstPageItem"}  eventKey={1} disabled={this.isOnFirstPage()}>&laquo;</Pager.Item>;
  }

  renderLastPageItem() {
    return <Pager.Item key={"paginationLastPageItem" } eventKey={this.totalPages} disabled={this.isOnLastPage()}>&raquo;</Pager.Item>;
  }

  renderPreviousPageItem() {
    return <Pager.Item key={"paginationPrevPageItem"} eventKey={this.props.pageNumber - 1} disabled={this.isOnFirstPage()}>&lsaquo;</Pager.Item>;
  }

  renderNextPageItem() {
    return <Pager.Item key={"paginationNextPageItem"} eventKey={this.props.pageNumber + 1} disabled={this.isOnLastPage()}>&rsaquo;</Pager.Item>;
  }

  render() {
    this.currentPageNumber = Number.parseInt(this.props.pageNumber, 10);

    return (
        <Pager onSelect={this.setPage} bsSize={"small"}>
          {this.renderFirstPageItem()}
          {this.renderPreviousPageItem()}
          {this.renderPages()}
          {this.renderNextPageItem()}
          {this.renderLastPageItem()}
        </Pager>
    )
  }
}

export default Paging;