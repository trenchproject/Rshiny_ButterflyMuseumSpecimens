---
title: "include2.md"
author: "Meera Lee Sethi"
date: "5/6/2019"
output: html_document
---

### Trait measurements 

For each butterfly specimen, MacLean measured three morphological traits. First, using digital photography and a computer program, she calculated the proportion of scales with dark pigmentation (or “melanism”) in a specific place on the underside of each hind-wing. You’ll see values for wing melanism that range from 0 (all pale scales) to 1 (all dark scales). As an aside, most butterflies bask in the sun by opening their wings flat, like a book, and exposing the top side. But *Colias* butterflies warm up by exposing the undersides of their wings, known as “lateral basking.” This is a key piece of information about their natural history that helped MacLean understand which parts of their wings to measure!

In addition, MacLean measured two other traits that you might expect to change with climate: Forewing length (remember the discussion of temperature and size above; warmer temperatures might result in smaller forewings) and setae length. Setae are hairs on a butterfly’s body that help to insulate it, like a fur coat. Longer setae keep butterflies warmer.

The image below shows two different *Colias* species, *Colias meadeii* and a relative that lives at a lower elevation. You can see the differences in wing melanism (absorbtivity is a measure of how much heat each specimen's wing is able to absorb) and in setae thickness (also called "fur").

![Low-elevation vs. high-elevation *Colias* butterfly traits, image: Heidi MacLean][http://faculty.washington.edu/lbuckley/wordpress/wp-content/uploads/2019/05/MacLean-slide.png]

### Exploring butterfly morphological data 

In this exercise, you can generate figures using the following variables:

1. Year (This is the year in which each specimen was collected. Include this variable when you want to look at changes over time.)
2. Day of year (This is the day of the year (Jan 1 is 1, December 31 is 365) when each specimen was collected. Since adult Colias butterflies only live a few days, this gives us a good estimate of their phenology, especially when they reached adulthood.)
3. Seasonal temperature (This is a measure of overall spring and summer temperatures in each year.)
4. Pupal temperature (This is an estimate of how warm it was specifically during the period when a particular specimen was pupating.)
5. Wing melanism (A measure of the darkness of the underwings.)
6. Forewing length (A measure of overall body size.)
7. Setae length (A measure of the longest setae between the first and second leg.)

In addition to selecting variables to display on the x- and y-axes, you have the option of coloring each data point according to a third variable. For example, to see whether pupal temperatures have changed over time, plot Year as the x-axis variable and Pupal temperature as the y-axis variable. If you then select Day of Year as the variable for Color, you’ll be able to see when each specimen was collected. This might be interesting if you wanted to see if pupal temperatures are changing because of climate change, OR because butterflies are experiencing a phenological shift.

Try to answer some of the following questions by changing the data you plot. For each, consider whether you see the same patterns at all three sites, or if different populations respond differently. Recall how each population occupies a different elevational range. How might this affect their responses?

* Have spring and summer temperatures increased over the years?
* Have butterfly wings lightened over the year?
* Have forewings or setae length decreased over the years?
* Do spring and summer temperatures affect the day of year when butterflies reach adulthood?