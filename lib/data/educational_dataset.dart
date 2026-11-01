import '../models/educational_content_model.dart';

final List<EducationalContentModel> educationalArticlesDataset = [
  const EducationalContentModel(
    contentId: 'edu-001',
    title: 'Biodiversity & The Web of Life',
    subtitle: 'Why every species loss triggers ecological cascade effects',
    category: 'Ecology & Biodiversity',
    readTimeMinutes: 5,
    imageUrl: 'assets/images/education/edu-001.jpg',
    description:
        'Biological diversity, or biodiversity, refers to the incredible variety of all life on Earth—from microscopic soil bacteria and fungi to towering redwood trees and blue whales. Every organism occupies a specialized ecological niche. When a keystone predator or pollinator is driven toward extinction, the delicate balance collapses, triggering trophic cascades that jeopardize clean water, nutrient cycling, food security, and climate regulation.',
    source: 'United Nations Environment Programme (UNEP) & WWF Living Planet Report',
    lastUpdated: '2024',
    keyPoints: [
      'Over 1 million animal and plant species are currently threatened with extinction globally.',
      'Keystone species have a disproportionately large impact on their environment relative to their abundance.',
      'Biodiverse ecosystems provide ecosystem services worth over \$125 trillion annually.',
      'Protecting 30% of global land and marine habitats by 2030 (30x30 Target) is critical for planetary stability.',
    ],
    howToHelp: [
      'Support habitat corridors that connect fragmented national parks and forests.',
      'Reduce single-use consumption and eliminate chemical pesticide runoff in your watershed.',
      'Engage in citizen science initiatives like iNaturalist and GBIF bioblitzes.',
    ],
  ),

  const EducationalContentModel(
    contentId: 'edu-002',
    title: 'Demystifying the IUCN Red List',
    subtitle: 'How scientists evaluate species risk using empirical criteria',
    category: 'Conservation Science',
    readTimeMinutes: 6,
    imageUrl: 'assets/images/education/edu-002.jpg',
    description:
        'The International Union for Conservation of Nature (IUCN) Red List of Threatened Species is the world’s most comprehensive information source on the global conservation status of animal, fungi, and plant species. It uses rigorous quantitative criteria based on population size, rate of decline, geographical distribution, and degree of population fragmentation to place species into nine precise categories ranging from Least Concern (LC) to Extinct (EX).',
    source: 'IUCN Species Survival Commission (SSC)',
    lastUpdated: '2024',
    keyPoints: [
      'CR (Critically Endangered): 50% or higher probability of extinction in the wild within 10 years or 3 generations.',
      'EN (Endangered): 20% probability of extinction within 20 years or 5 generations.',
      'VU (Vulnerable): 10% probability of extinction within 100 years.',
      'Assessments are conducted by thousands of volunteer scientific specialists worldwide and peer-reviewed.',
    ],
    howToHelp: [
      'Always check official IUCN assessment dates rather than relying on unverified social media claims.',
      'Support botanical gardens, zoological research institutes, and seed banks maintaining Red List data.',
      'Advocate for national wildlife protection legislation aligned with IUCN thresholds.',
    ],
  ),

  const EducationalContentModel(
    contentId: 'edu-003',
    title: 'Combating the Illegal Wildlife Trade',
    subtitle: 'Enforcing CITES and ending poaching networks',
    category: 'Wildlife Protection',
    readTimeMinutes: 5,
    imageUrl: 'assets/images/education/edu-003.jpg',
    description:
        'The illegal wildlife trade is one of the most lucrative illicit transnational crimes globally, worth billions of dollars annually. It decimates populations of pangolins, rhinoceroses, tigers, parrots, and sea turtles for exotic pets, decorative curios, bushmeat, and unverified folk remedies. The Convention on International Trade in Endangered Species of Wild Fauna and Flora (CITES) establishes legal international regulations to protect endangered animals from commercial exploitation.',
    source: 'TRAFFIC & CITES Secretariat',
    lastUpdated: '2024',
    keyPoints: [
      'Appendix I bans all international commercial trade in species threatened with extinction.',
      'Appendix II controls trade to prevent utilization incompatible with wild species survival.',
      'DNA forensic profiling is now utilized by border agents to trace smuggled animal parts to their exact geographic origins.',
      'Community ranger programs that offer fair living wages drastically reduce local poaching pressures.',
    ],
    howToHelp: [
      'Never purchase souvenirs or traditional crafts made from ivory, tortoiseshell, animal furs, or coral.',
      'Refuse photo-ops with captive wild animals subjected to sedation or exploitation.',
      'Report suspected online wildlife trafficking listings to anti-poaching watchdog agencies.',
    ],
  ),

  const EducationalContentModel(
    contentId: 'edu-004',
    title: 'Climate Change & Marine Life Resilience',
    subtitle: 'Warming seas, ocean acidification, and shifting migrations',
    category: 'Marine Conservation',
    readTimeMinutes: 4,
    imageUrl: 'assets/images/education/edu-004.jpg',
    description:
        'The world\'s oceans have absorbed over 90% of excess heat generated by greenhouse gas emissions and roughly 30% of anthropogenic carbon dioxide. This thermal accumulation triggers catastrophic coral bleaching, ocean acidification, and shifts in marine productivity. Pelagic giants like blue whales and whale sharks must travel thousands of miles farther to find krill and plankton blooms, increasing encounters with commercial shipping corridors and fishing gear.',
    source: 'Intergovernmental Panel on Climate Change (IPCC) & NOAA Ocean Service',
    lastUpdated: '2024',
    keyPoints: [
      'Coral reefs support over 25% of all marine species despite occupying less than 1% of the ocean floor.',
      'Acidified seawater dissolves the calcium carbonate shells of pteropods, the fundamental base of polar food webs.',
      'Marine Protected Areas (MPAs) that prohibit bottom trawling allow fish populations and benthic biomes to rebuild resilience.',
    ],
    howToHelp: [
      'Choose seafood certified by sustainable fisheries management programs (e.g., MSC certified).',
      'Reduce your personal carbon footprint by using renewable energy and efficient transit.',
      'Support local coastal cleanup operations that remove ghost fishing gear and plastic waste.',
    ],
  ),
];
