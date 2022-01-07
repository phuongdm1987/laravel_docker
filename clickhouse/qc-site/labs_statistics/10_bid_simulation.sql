DROP TABLE IF EXISTS distributed_bid_simulation;
CREATE TABLE distributed_bid_simulation
(
    id UInt64, -- id of either match,advert or campaign
    date DATE, -- date on which the simulation was conducted
    simulation_level String,  -- level of simulation, could be match, advert, campaign
    placement_type String,
    recommended_bids Array(Float64), -- array of recommended bids
    estimated_shows Array(Float64),  -- array of estimated show corresponding to the bid array
    estimated_clicks Array(Float64), -- array of estimated click corresponding to the bid array
    current_bid_index Int16, -- index of the current bid, corresponding show and click of the user
    top_block_bid_index Int16, -- index of the bid, show and click to win X% of the auctions at pos0 of block
    bottom_block_bid_index Int16, -- index of the bid, show and click to win Y% of the auctions at bottom block
    version LowCardinality(String), -- application version
    simulation_days UInt16 default 7
)
    ENGINE = MergeTree()
    PARTITION BY toYYYYMM(date)
ORDER BY (date, simulation_level, placement_type, intHash64(id));