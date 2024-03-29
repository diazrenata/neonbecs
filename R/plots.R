#' @title Replicate Figure 1
#' @description plot all 9 BSEDs or BSDs in the same arrangement as Ernest Figure 1
#' @param dists list of bseds or bsds, or P values for BSED bootstrap analysis
#' @param dist_type "bsed", "bsd", "isd", "gmm_pdf", or "bsed_bootstraps"
#' @return 9 panel plot modeled after Ernest 2005 Figure 1
#' @export
#'
plot_paper_dists <- function(dists, dist_type){
  dists_plots <- list()

  if(dist_type == "bsed") {dist_plot_fun = plot_bsed}
  if(dist_type == "bsd") {dist_plot_fun = plot_bsd}
  if(dist_type == "bsed_bootstraps") {dist_plot_fun = plot_bsed_bootstrap_results}
  if(dist_type == "isd") {dist_plot_fun = plot_isd}
  if(dist_type == "gmm_pdf") {dist_plot_fun = plot_gmm_pdf}

  for(i in 1:length(dists)) {
    dists_plots[[i]] <- dist_plot_fun(dists[[i]], names(dists)[i])
    names(dists_plots)[i] <- names(dists)[i]
  }

  dists_plot <- gridExtra::grid.arrange(dists_plots$andrews, dists_plots$niwot,  dists_plots$`sev-goatdraw`,
                                        dists_plots$`sev-5pgrass`,  dists_plots$`sev-rsgrass`,  dists_plots$`sev-two22`,
                                        dists_plots$`sev-5plarrea`,  dists_plots$`sev-rslarrea`,  dists_plots$portal, nrow = 3)

  return(dists_plot)

}

#' Plot PDF from GMM
#' @param gmm_pdf the pdf
#' @param pdf_name the name of the community, defaults null
#' @return density plot
#' @export
plot_gmm_pdf <- function(gmm_pdf, pdf_name = NULL) {
  if(!is.null(pdf_name)) {
    plot_title <- paste0("PDF: ", pdf_name)
  } else {
    plot_title <- "PDF"
  }

  pdf_plot <- ggplot2::ggplot(data = gmm_pdf, ggplot2::aes(x = sizes, y = density)) +
    ggplot2::scale_x_discrete(limits = c(0, 8)) +
    ggplot2::geom_smooth(stat = "identity", ggplot2::aes(x = gmm_pdf$sizes, y = gmm_pdf$density)) +
    ggplot2::labs(x = "Size (log)", y = "Density", title = plot_title) +
    ggplot2::theme_bw()

  return(pdf_plot)

}

#' @title Plot ied
#' @param ied result of `make_isd`
#' @param ied_name community name, defaults NULL
#' @return plot of IED
#' @export
plot_ied <- function(ied, ied_name = NULL) {

  if(!is.null(ied_name)) {
    plot_name = paste0("Individuals energy distribution: ", ied_name)
  } else {
    plot_name = "Individuals energy distribution"
  }

  this_ied_plot <- ggplot2::ggplot(data = ied, ggplot2::aes(ied$ln_energy, xmin = 0, xmax = 1)) +
    ggplot2::geom_histogram(data = ied, stat = "bin",
                            binwidth = 0.01,
                            show.legend = NA,
                            inherit.aes = TRUE)  +
    ggplot2::labs(x = "ln(energy)", y = "Number of individuals", title = plot_name) +
    ggplot2::theme_bw()

  return(this_ied_plot)
}


#' @title Plot isd
#' @param isd result of `make_isd`
#' @param isd_name community name, defaults NULL
#' @return plot of ISD
#' @export
plot_isd <- function(isd, isd_name = NULL){

  if(!is.null(isd_name)) {
    plot_name = paste0("Individuals size distribution: ", isd_name)
  } else {
    plot_name = "Individuals size distribution"
  }

  this_isd_plot <- ggplot2::ggplot(data = isd, ggplot2::aes(isd$ln_size, xmin = 0, xmax = 1)) +
    ggplot2::geom_histogram(data = isd, stat = "bin",
                            binwidth = 0.01,
                            show.legend = NA,
                            inherit.aes = TRUE)  +
    ggplot2::labs(x = "ln(size)", y = "Number of individuals", title = plot_name) +
    ggplot2::theme_bw()

  return(this_isd_plot)
}
